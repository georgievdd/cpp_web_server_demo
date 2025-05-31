#pragma once
#include "../server/server.h"
#include "./mime.h"

#define route(name, args...) void name(crow::request& req, crow::response& res, ##args)

route(check);
route(staticRoute, const std::string&);
