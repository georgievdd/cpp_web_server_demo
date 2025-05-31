#include "../index.h"

void configureRoutes() {
    get("/check")(check);
    get("/public/<path>")(staticRoute);
}
