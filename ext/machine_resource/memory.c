#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include "machine_resource.h"

typedef struct {
  float total;
  float free;
  float used;
  float cache;
} MemoryInfo;

MemoryInfo get_memory_info(const char *unit) {
  float mb_divisor = (strcmp(unit, "MB") == 0) ? 1024.0f : 1048576.0f;
  
  MemoryInfo info;
  FILE* meminfo = fopen("/proc/meminfo", "r");

  if (meminfo == NULL) {
    printf("Error opening /proc/meminfo\n");
    return info;
  }
  char line[256];
  while (fgets(line, sizeof(line), meminfo)) {
    unsigned long long value;
    if (sscanf(line, "MemTotal: %llu kB", &value) == 1) {
      info.total = roundToTwoDecimals(value / mb_divisor);
    } else if (sscanf(line, "MemFree: %llu", &value) == 1) {
      info.free = roundToTwoDecimals(value / mb_divisor);
    } else if (sscanf(line, "Cached: %llu kB", &value) == 1) {
      info.cache = roundToTwoDecimals(value / mb_divisor);
      break;
    }
  }
  fclose(meminfo);

  info.used = info.total - info.free - info.cache;
  return info;
}

void Init_memory() {
    // Initialization code for your extension
}