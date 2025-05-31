#include "../controllers.h"

route(check) {
    MIME_APPLICATION_JSON
    res.write(Json({{"code", 200}, {"message", "ok"}}).dump());
    res.end();
}
