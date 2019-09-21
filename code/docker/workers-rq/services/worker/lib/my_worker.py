import logging
import time

def work(n=10):
    print("Going to work!")
    for ii in range(n):
        print(f"{ii}: working...")
        time.sleep(1)
    print("Done!")
