import subprocess
from threading import Thread

def call_shell():
    try:
        subprocess.call("sdf", shell=True)
        print("call_shell")
    except:
        print("error in call_shell")

def call():
    try:
        subprocess.call("sdf")
        print("call")
    except:
        print("error in call")

def popen():
    try:
        subprocess.Popen("sdfsd")
        print("popen")
    except:
        print("error in popen")

def popen_shell():
    try:
        subprocess.Popen("sdfsd", shell=True)
        print("popen_shell")
    except:
        print("error in popen_shell")

def check_output_shell():
    try:
        subprocess.check_output("sdfasd", shell=True)
        print("check_output_shell")
    except:
        print("error in check_output_shell")

def check_output():
    try:
        subprocess.check_output("sdfasd")
        print("check_output")
    except:
        print("error in check_output")

Thread(target=call_shell).start()
Thread(target=call).start()
Thread(target=popen).start()
Thread(target=popen_shell).start()
Thread(target=check_output_shell).start()
Thread(target=check_output).start()
