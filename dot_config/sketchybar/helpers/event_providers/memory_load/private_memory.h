#include <mach/mach.h>
#include <mach/vm_statistics.h>
#include <sys/sysctl.h>
#include <stdbool.h>
#include <stdio.h>

struct memory {
  host_t host;
  mach_msg_type_number_t count;
  vm_statistics64_data_t vm_stat;

  uint64_t total_memory;
  uint64_t used_memory;
  uint64_t free_memory;
  int usage_percent;
};

static inline void memory_init(struct memory* mem) {
  mem->host = mach_host_self();
  mem->count = HOST_VM_INFO64_COUNT;

  // Get total physical memory
  int mib[2] = { CTL_HW, HW_MEMSIZE };
  size_t size = sizeof(mem->total_memory);
  sysctl(mib, 2, &mem->total_memory, &size, NULL, 0);
}

static inline void memory_update(struct memory* mem) {
  kern_return_t error = host_statistics64(mem->host,
                                          HOST_VM_INFO64,
                                          (host_info64_t)&mem->vm_stat,
                                          &mem->count);

  if (error != KERN_SUCCESS) {
    printf("Error: Could not read memory statistics.\n");
    return;
  }

  // Get page size
  vm_size_t page_size;
  host_page_size(mem->host, &page_size);

  // Calculate memory usage
  // Used = Active + Wired + Compressed
  // Free = Free + Inactive + Speculative (available for use)
  uint64_t active = (uint64_t)mem->vm_stat.active_count * page_size;
  uint64_t wired = (uint64_t)mem->vm_stat.wire_count * page_size;
  uint64_t compressed = (uint64_t)mem->vm_stat.compressor_page_count * page_size;

  mem->used_memory = active + wired + compressed;
  mem->free_memory = mem->total_memory - mem->used_memory;
  mem->usage_percent = (int)((double)mem->used_memory / (double)mem->total_memory * 100.0);
}
