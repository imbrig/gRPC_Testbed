#include <grpcpp/grpcpp.h>
#include "testbed.grpc.pb.h"
#include <iostream>

using grpc::Server;
using grpc::ServerBuilder;
using grpc::ServerContext;
using grpc::ServerWriter;
using grpc::Status;
using testbed::HelloRequest;
using testbed::HelloResponse;
using testbed::HelloStreamResponse;
using testbed::HelloService;

class HelloServiceImpl final : public HelloService::Service {
  Status Hello(ServerContext* context, const HelloRequest* request, HelloResponse* reply) override {
    std::cout << "Got a request from the client." << std::endl;
    std::string prefix("Hello silly face, ");
    reply->add_values(prefix + request->value());
    return Status::OK;
  }

  Status HelloStream(ServerContext* context, const HelloRequest* request, ServerWriter<HelloStreamResponse>* writer) override {
    std::cout << "Got a streaming request from the client." << std::endl;
    for (uint32_t i = 0; i < request->extra_times(); ++i) {
      HelloStreamResponse response;
      response.set_value("Hello " + request->value() + " number " + std::to_string(i));
      writer->Write(response);
    }
    return Status::OK;
  }
};

void RunServer() {
  std::string server_address("127.0.0.1:50051");
  HelloServiceImpl service;

  ServerBuilder builder;
  builder.AddListeningPort(server_address, grpc::InsecureServerCredentials());
  builder.RegisterService(&service);
  std::unique_ptr<Server> server(builder.BuildAndStart());
  std::cout << "Server listening on " << server_address << std::endl;
  server->Wait();
}

int main(int argc, char** argv) {
  RunServer();
  return 0;
}
