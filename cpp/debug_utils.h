#ifdef __cplusplus
#include <cstdint>
#else
#include <stdint.h>
#endif

#if defined(__GNUC__) || defined(__clang__)
    #define FORCE_INLINE __attribute__((always_inline)) inline
#else
    #define FORCE_INLINE inline
#endif

#ifdef __cplusplus
namespace dbg {
#endif

FORCE_INLINE void breakpoint(void) {
#if defined(__x86_64__) || defined(_M_X64) || defined(__i386__) || defined(_M_IX86)
    // x86/x86-64 architecture
    __asm__ volatile("int $0x03");
#elif defined(__aarch64__) || defined(_M_ARM64)
    // ARM64 architecture
    __asm__ volatile("brk #0");
#elif defined(__arm__) || defined(_M_ARM)
    // ARM (32-bit) architecture
    __asm__ volatile("bkpt #0");
#elif defined(__riscv)
    // RISC-V architecture
    __asm__ volatile("ebreak");
#elif defined(_MSC_VER)
    // MSVC intrinsic
    __debugbreak();
#else
    // Fallback for other architectures - may not work everywhere
    volatile uintptr_t* p = 0;
    *p = 0;
#endif
}

#ifdef __cplusplus
} // namespace dbg
#endif

#undef FORCE_INLINE
