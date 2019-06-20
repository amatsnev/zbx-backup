#! /usr/bin/python3
import os,re
import argparse
import datetime,time
import glob
regex = r'([\w.-]*)[-_](20[12]\d)[-_](\d{2})[-_](\d{2})[-_](\d{2})[-_]?(\d{2})\S*(?:backup.gpg|backup|7z.gpg)\b'
backup_exclude = ['postgres', 'null_base' ]

parser = argparse.ArgumentParser()
parser.add_argument("--list-backups", "-L", help="list all backups ", action="store_true")
parser.add_argument("--backup-dir", "-B", help="set backup dir", action='store',default="/backup-all")
parser.add_argument("--last-backup" , help="show last backup date of BACKUP", action="store")

args = parser.parse_args()
path=args.backup_dir 
fileList = glob.glob(path + '/**/*', recursive=True)
f1 = [re.findall(regex,x) for x in fileList]
f1 = list(filter(None,f1))
f2=[]
[ f2.append(x[0]) for x in f1 ]
f2=sorted(f2,reverse=True)
dict1= dict()
for x in f2:
 if x[0] not in backup_exclude :
  if x[0] not in dict1:   dict1[x[0]]=list()
  dict1[x[0]].append([x[1],x[2],x[3],x[4],x[5]])

  
if args.list_backups:
 out1 = "{\"data\": ["
 for x in list(dict1) : out1 += "{\"{#BACKUP}\":\"" + x +"\"},"
 out1 =out1[:-1]
 out1 +=  "]}"
 print(out1)

if args.last_backup: 
 lf=(dict1[args.last_backup][0])
# print (lf)
# print (dict1[args.last_backup])
 s=lf[0]+lf[1]+lf[2]+lf[3]+lf[4]

 d=datetime.datetime.strptime(s, "%Y%m%d%H%M").timestamp()
 print (d)

 
#print (dict1)
#[ print(dict1[x])  for x in list(dict1) ]
#print (list(dict1))
#+' ' + dict1[x][0])