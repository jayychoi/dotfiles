#include <unistd.h>
#include "disk.h"
#include "../sketchybar.h"

int main (int argc, char** argv) {
  float update_freq;
  if (argc < 4 || (sscanf(argv[3], "%f", &update_freq) != 1)) {
    printf("Usage: %s \"<mount-point>\" \"<event-name>\" \"<event_freq>\"\n", argv[0]);
    exit(1);
  }

  alarm(0);
  struct disk disk;
  disk_init(&disk, argv[1]);

  // Setup the event in sketchybar
  char event_message[512];
  snprintf(event_message, 512, "--add event '%s'", argv[2]);
  sketchybar(event_message);

  char trigger_message[512];
  for (;;) {
    // Acquire new info
    disk_update(&disk);

    // Prepare the event message
    snprintf(trigger_message,
             512,
             "--trigger '%s' usage='%02d' used='%llu' free='%llu' total='%llu'",
             argv[2],
             disk.usage_percent,
             disk.used_space / (1024 * 1024 * 1024),  // GB
             disk.free_space / (1024 * 1024 * 1024),  // GB
             disk.total_space / (1024 * 1024 * 1024)  // GB
    );

    // Trigger the event
    sketchybar(trigger_message);

    // Wait
    usleep(update_freq * 1000000);
  }
  return 0;
}
