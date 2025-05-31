#include "./controllers/index.h"

int main() {

    configureRoutes();

    run(8086);

    return 0;
}