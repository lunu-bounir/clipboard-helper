#include <iostream>
#include <string>
#include "json.hpp"
#include "clip/clip.h"

using json = nlohmann::json;

void ClipboardWait();

int main() {
  while (1) {
    unsigned int length = 0;

    for (int i = 0; i < 4; i++) {
      unsigned int read_char = getchar();
      length = length | (read_char << i*8);
    }

    //read message
    std::string message = "";
    for (unsigned int i = 0; i < length; i++) {
      message += getchar();
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
    std::cout << char(len>>0) << char(len>>8) << char(len>>16) << char(len>>24);
    std::cout << message << std::flush;
  }

  return 0;
}
