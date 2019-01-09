#include <iostream>
#include <string>
#include "json.hpp"
#include "clip/clip.h"

using json = nlohmann::json;

void ClipboardWait();

int main() {
  std::cout.setf(std::ios_base::unitbuf);
  while (true) {
    unsigned int ch, inMsgLen = 0;
    std::string message = "";

    // Read 4 bytes for data length
    std::cin.read((char*)&inMsgLen, 4);

    if (inMsgLen == 0) {
      break;
    }
    else {
      for (unsigned int i=0; i < inMsgLen; i++) {
        ch = getchar();
        message += ch;
      }
    }

    auto request = json::parse(message);

    // write message
    json response;

    if (request["method"] == "write") {
      response["result"] = clip::set_text(request["value"]);
    }
    else if (request["method"] == "wait") {
      ClipboardWait();
      response["result"] = true;
    }
    else if (request["method"] == "read" || request["method"] == "read-next") {
      if (request["method"] == "read-next") {
        ClipboardWait();
      }
      std::string value;
      clip::get_text(value);
      // limit to 1M
      response["result"] = value.substr(0, 1024 * 1024 - 5000);
      response["length"] = value.length();
    }
    else {
      throw (request["method"], " method is not supported");
    }

    message = response.dump();
    unsigned int len = message.length();

    // Send 4 bytes of data length
    std::cout.write((char*)&len, 4);
    // Send the data
    std::cout << message;
  }

  return 0;
}
