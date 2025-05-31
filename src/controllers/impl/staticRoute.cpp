#include "../controllers.h"

route(staticRoute, const std::string& filePath) {
    res.set_static_file_info("public/" + filePath);
    res.end();
}
