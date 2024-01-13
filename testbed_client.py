import asyncio
import build.proto_py.testbed as testbed

from grpclib.client import Channel

async def main():
    channel = Channel(host="127.0.0.1", port=50051)
    service = testbed.HelloServiceStub(channel)
    response = await service.hello(testbed.HelloRequest(value="hello", extra_times=1))

    for value in response.values:
        print("Greeter client received: " + value)

    async for response in service.hello_stream(testbed.HelloRequest(value="hello", extra_times=1)):
        print(response)

    # don't forget to close the channel when done!
    channel.close()

if __name__ == '__main__':
    loop = asyncio.get_event_loop()
    loop.run_until_complete(main())
