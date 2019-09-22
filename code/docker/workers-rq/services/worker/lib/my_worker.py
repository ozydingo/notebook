import logging
import time

logger = logging.getLogger("worker")
logfh = logging.FileHandler("/proc/1/fd/1", "w")
logfh.setLevel(logging.DEBUG)
logger.addHandler(logfh)

def work(n=10):
    logger.info("Going to work!")
    for ii in range(n):
        logger.info(f"{ii}: working...")
        time.sleep(1)
    logger.info("Done!")
