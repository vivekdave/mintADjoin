#!/usr/bin/python3
from sys import argv

file0, file1 = argv
print(file1)


f = open(file1,'r',encoding = 'utf-8')

filedata = f.read()

if filedata.find('session required pam_mkhomedir.so skel=/home/template/ umask=0022') > 0:
    print("Template user already applied to the pam")
else:
    filedata = filedata.replace('# and here are more per-package modules (the "Additional" block)', '# and here are more per-package modules (the "Additional" block)\nsession required pam_mkhomedir.so skel=/home/template/ umask=0022')
    
    with open(file1, 'w') as file:
        file.write(filedata)


