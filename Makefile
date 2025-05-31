TARGET = enrtypoint
SRC_DIR = src
BUILD_DIR = build
INC_DIR = include

SOURCES := $(shell find $(SRC_DIR) -name '*.cpp')
OBJECTS := $(SOURCES:$(SRC_DIR)/%.cpp=$(BUILD_DIR)/%.o)

CROW_INC = -Ilibs/Crow/include
ASIO_INC = -Ilibs/asio/include
PROJECT_INC = -I$(INC_DIR)
DEFINES = -DCROW_USE_STANDALONE_ASIO

CXXFLAGS = -g -fsanitize=address -std=c++17 -pthread $(PROJECT_INC) $(CROW_INC) $(ASIO_INC) $(DEFINES)
LDFLAGS = -lpthread

all: clean compile run

compile: $(BUILD_DIR)/$(TARGET)

$(BUILD_DIR)/$(TARGET): $(OBJECTS)
	g++ $(CXXFLAGS) $^ -o $@ $(LDFLAGS)

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.cpp
	mkdir -p $(@D)
	g++ $(CXXFLAGS) -c $< -o $@

run:
	sudo ./$(BUILD_DIR)/$(TARGET)

clean:
	rm -rf $(BUILD_DIR)

.PHONY: all run clean compile
