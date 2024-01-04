#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

int cpu_count(FILE* file){
  file = fopen("/proc/stat", "r");
  if (file == NULL) {
    perror("Error opening /proc/stat");
  }
  int cpu_count = 1;
  char line[256];
  while (fgets(line, sizeof(line), file) && strncmp(line, "cpu", 3) == 0) {
    if (strncmp(line, "cpu  ", 5) != 0) {
      cpu_count++;
    }
  }
  fclose(file);
  return cpu_count;
}

void assign_cpu_info(FILE* file, int* x, int* y){
  file = fopen("/proc/stat", "r");
  if (file == NULL) {
    perror("Error opening /proc/stat");
  }

  int i = 0;
  int user, nice, system, idle, iowait, irq, softirq, steal, guest;
  char line[256], cpu_name[5];

  while (fgets(line, sizeof(line), file) && strncmp(line, "cpu", 3) == 0) {
    if (strncmp(line, "cpu  ", 5) != 0) {
      sscanf(line, "%s %d %d %d %d %d %d %d %d %d", cpu_name, &user, &nice, &system, &idle, &iowait, &irq, &softirq, &steal, &guest);
      y[i] = user + nice + system + idle + iowait + irq + softirq + steal + guest;
      x[i] = y[i] - idle;
      i++;
    }
  }

  fclose(file);
}

float *get_cpu_info() {
  FILE *file;

  int cpus = cpu_count(file);
  int init_idle[cpus], curr_idle[cpus];
  int init_total[cpus], curr_total[cpus];
  float *usage = malloc(cpus * sizeof(float));

  assign_cpu_info(file, init_idle, init_total);
  sleep(1);
  assign_cpu_info(file, curr_idle, curr_total);

  for (int i = 0; i < cpus; i++) {
    int total_delta = curr_total[i] - init_total[i];
    int idle_delta = curr_idle[i] - init_idle[i];

    if (total_delta > 0) {
      float usage_percentage = 500 - 100 - (100.0 * (total_delta - idle_delta) / total_delta);
      usage[i] = usage_percentage;
    } else {
      usage[i] = 0.0;
    }
  }
  return usage;
}

void Init_cpu() {
    // Initialization code for your extension
}