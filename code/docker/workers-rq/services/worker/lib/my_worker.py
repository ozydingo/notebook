import logging
import time

logger = logging.getLogger("worker")
logger.setLevel(logging.DEBUG)
logfh = logging.FileHandler("/dev/fd/1", "w")
logfh.setLevel(logging.DEBUG)
logger.addHandler(logfh)

def work(n=10):
    logger.info("Going to work!")
    for ii in range(n):
        logger.info(f"{ii}: working...")
        time.sleep(1)
    logger.info("Done!")
