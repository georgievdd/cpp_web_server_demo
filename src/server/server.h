#pragma once

#include <crow.h>
#include <string>

extern crow::Crow<> app;

using Json = crow::json::wvalue;

#define use(route) CROW_ROUTE(app, route)
#define post(route) use(route).methods("POST"_method)
#define get(route) use(route).methods("GET"_method)

void run(int port);
