#ifdef __cplusplus
#include <cstdint>
#include <iostream>
#include <sstream>
#include <string_view>
#include <vector>
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
template<typename T>
void print_var(const std::string_view name, const T& value) {
    std::cout << name << "=" << value << std::endl;
}

template<typename T>
std::string format_var(const std::string_view name, const T& value) {
    std::ostringstream oss;
    oss << name << "=" << value;
    return oss.str();
}

template <typename T>
struct DefaultHandler {
    void operator()(const T& val) {
        //std::cout << val << '\n';
        dbg::breakpoint();
    }
};

template <typename T, typename CallbackType = DefaultHandler<T>>
class debug_vector : public std::vector<T> {
private:
    CallbackType callback;
public:
    using std::vector<T>::vector;
    void push_back(const T& value) {
        callback(value);
        std::vector<T>::push_back(value);
    }
};

#endif

#ifdef __cplusplus
} // namespace dbg
#endif

#ifdef __cplusplus
#define NAME_AND_VAL(var) #var, var
#define PRINT_VAR(var) dbg::print_var(NAME_AND_VAL(var))
#define FORMAT_VAR(var) dbg::format_var(NAME_AND_VAL(var))
#endif

#undef FORCE_INLINE
