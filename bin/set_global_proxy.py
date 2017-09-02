#!/usr/bin/python3
from sys import argv
import os

http='http_proxy="http://10.0.0.1:3128"'
https='https_proxy="http://10.0.0.1:3128"'
ftp='ftp_proxy="http://10.0.0.1:3128"'


# Get the file permision of a file so as we can re set it.
def get_file_prem(file):
    return oct(os.stat(file).st_mode)[-3:]

def set_file_prem(fileToEdit, perm):
    from subprocess import call, run
    data=run(["chmod", str(perm), fileToEdit])
    if data.returncode == 0:
        True
    else:
        False

#set_file_prem("/etc/environment", 644)
#print(get_file_prem("/etc/environment"))


def add_edit_global_env_vars(env):
    enviroment_file = '/etc/environment'
    #print(env)
    equal_sym = env.find('=')
    env_key = env[:equal_sym]
    #print(env_key)

    f = open(enviroment_file,'r',encoding = 'utf-8')
    filedata = f.readlines()
    #print(len(filedata))
    data_found=False
    for i in range(len(filedata)):
        #print("list iter" + str(i))
        #print("file data" + str(i) + " | " + filedata[i])
        if filedata[i].find(env_key) != -1:
            #print("inside if" + str(i) + " | " + filedata[i])
            filedata[i] = env+"\n"
            data_found=True
    
    #print("out of for loop")        
    if data_found == False:
        filedata.append(env+"\n")

    with open(enviroment_file, 'w') as file:
        file.writelines(filedata)
    #print(filedata)
        

file_permission = get_file_prem("/etc/environment")

add_edit_global_env_vars(http)
add_edit_global_env_vars(https)
add_edit_global_env_vars(ftp)

set_file_prem("/etc/environment", file_permission)
