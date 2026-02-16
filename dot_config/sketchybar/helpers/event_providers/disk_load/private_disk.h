#include <sys/mount.h>
#include <stdbool.h>
#include <stdio.h>
#include <string.h>

struct disk {
  char mount_point[256];
  struct statfs fs_stat;

  uint64_t total_space;
  uint64_t used_space;
  uint64_t free_space;
  int usage_percent;
};

static inline void disk_init(struct disk* disk, char* mount_point) {
  memset(disk, 0, sizeof(struct disk));
  strncpy(disk->mount_point, mount_point, sizeof(disk->mount_point) - 1);
}

static inline void disk_update(struct disk* disk) {
  if (statfs(disk->mount_point, &disk->fs_stat) != 0) {
    printf("Error: Could not read disk statistics for %s.\n", disk->mount_point);
    return;
  }

  uint64_t block_size = disk->fs_stat.f_bsize;

  disk->total_space = disk->fs_stat.f_blocks * block_size;
  disk->free_space = disk->fs_stat.f_bavail * block_size;  // Available to non-root
  disk->used_space = disk->total_space - disk->free_space;
  disk->usage_percent = (int)((double)disk->used_space / (double)disk->total_space * 100.0);
}
