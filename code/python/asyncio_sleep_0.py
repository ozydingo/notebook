import asyncio
import time

async def value():
    return 42

async def task1():
    for ii in range(10):
        print(f"- {ii}")
        await asyncio.sleep(0.1)

async def task2():
    for ii in range(20):
        x = await value()
        print(f"----- {ii}, {x}")
        time.sleep(0.02)

async def main():
    t1 = asyncio.create_task(task1())
    t2 = asyncio.create_task(task2())

    (done, pending) = await asyncio.wait([t1, t2])

asyncio.run(main())
