from __future__ import print_function
import grpc
import testbed_pb2
import testbed_pb2_grpc

def run():
    channel = grpc.insecure_channel('127.0.0.1:50051')
    stub = testbed_pb2_grpc.GreeterStub(channel)
    response = stub.SayHello(testbed_pb2.HelloRequest(name='client'))
    print("Greeter client received: " + response.message)

if __name__ == '__main__':
    run()
