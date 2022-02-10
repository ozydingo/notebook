import asyncio
import time

async def task1():
    for ii in range(10):
        print(f"- {ii}")
        await asyncio.sleep(0.1)

async def task2():
    for ii in range(5):
        print(f"----- {ii}")
        time.sleep(2)

async def task3():
    for ii in range(5):
        print(f"----- {ii}")
        await asyncio.sleep(0.5)

async def bad():
    t1 = asyncio.create_task(task1())
    t2 = asyncio.create_task(task2())

    (done, pending) = await asyncio.wait([t1, t2])

async def good():
    t1 = asyncio.create_task(task1())
    t3 = asyncio.create_task(task3())

    (done, pending) = await asyncio.wait([t1, t3])

print("---GOOD---")
asyncio.run(good())
print("---BAD---")
asyncio.run(bad())
