#!/usr/bin/env python3
"""Generate immutable package indexes and signed, expiring APT metadata."""
import argparse, datetime, email.utils, gzip, hashlib, os, pathlib, shutil, subprocess
p=argparse.ArgumentParser()
p.add_argument('--root',type=pathlib.Path,required=True)
p.add_argument('--gpg-home',type=pathlib.Path,required=True)
p.add_argument('--key',required=True)
p.add_argument('--timestamp',type=int)
p.add_argument('--valid-days',type=int,default=30,choices=range(1,61))
a=p.parse_args();root=a.root.resolve()
for suite in ['noble','trixie']:
 if not list((root/'pool'/suite).glob('*.deb')):p.error('Missing packages for '+suite)
now=datetime.datetime.fromtimestamp(a.timestamp,datetime.timezone.utc) if a.timestamp is not None else datetime.datetime.now(datetime.timezone.utc)
def date(value):return email.utils.format_datetime(value,usegmt=True)
def atomic(path,data):
 path.parent.mkdir(parents=True,exist_ok=True)
 temporary=path.with_name(path.name+'.tmp');temporary.write_bytes(data);os.replace(temporary,path)
public=subprocess.check_output(['gpg','--homedir',str(a.gpg_home),'--batch','--export',a.key])
if not public:raise RuntimeError('Public key export is empty')
atomic(root/'archive-key.gpg',public)
for suite in ['noble','trixie']:
 dist=root/'dists'/suite;binary=dist/'main/binary-amd64';binary.mkdir(parents=True,exist_ok=True)
 packages=subprocess.check_output(['apt-ftparchive','packages','pool/'+suite],cwd=root)
 atomic(binary/'Packages',packages);atomic(binary/'Packages.gz',gzip.compress(packages,mtime=0))
 checksum=[]
 for name in ['Packages','Packages.gz']:
  path=binary/name;data=path.read_bytes();digest=hashlib.sha256(data).hexdigest()
  atomic(binary/'by-hash/SHA256'/digest,data)
  checksum.append(f' {digest} {len(data)} main/binary-amd64/{name}')
 release=f'Origin: scrcpy-manager\nLabel: scrcpy Manager\nSuite: {suite}\nCodename: {suite}\nArchitectures: amd64\nComponents: main\nDate: {date(now)}\nValid-Until: {date(now+datetime.timedelta(days=a.valid_days))}\nAcquire-By-Hash: yes\nDescription: scrcpy Manager Linux Preview packages\nSHA256:\n'+'\n'.join(checksum)+'\n'
 atomic(dist/'Release',release.encode())
 base=['gpg','--homedir',str(a.gpg_home),'--batch','--yes','--local-user',a.key,'--digest-algo','SHA256']
 for name,options in [('InRelease',['--clearsign']),('Release.gpg',['--armor','--detach-sign'])]:
  temporary=dist/(name+'.tmp')
  subprocess.run(base+['--output',str(temporary)]+options+[str(dist/'Release')],check=True)
  os.replace(temporary,dist/name)
print('Signed APT indexes for noble/trixie; Valid-Until',date(now+datetime.timedelta(days=a.valid_days)))
