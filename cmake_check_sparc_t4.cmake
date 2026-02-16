include(CheckCSourceRuns)

if (CMAKE_SYSTEM_PROCESSOR MATCHES "sparc")
    set(_SPARC_T4_TEST_SOURCE "
    #include <signal.h>
    #include <stdlib.h>

    static void sigill_handler(int signo)
    {
        (void)signo;
        exit(1);
    }

    int main(void)
    {
        signal(SIGILL, sigill_handler);

    #if defined(__sparc__)
        asm volatile (\"rd %%asr26, %%g0\\n\\t\" :::);
    #else
    #error Not SPARC
    #endif

        return 0;
    }
    ")

    if (CMAKE_CROSSCOMPILING)
        message(FATAL_ERROR
            "Cross-compiling for SPARC: SPARC_T4 cannot be auto-detected. "
            "Please set -DSPARC_T4=ON or OFF explicitly.")
    endif()

    check_c_source_runs("${_SPARC_T4_TEST_SOURCE}" SPARC_T4)
else()
    set(SPARC_T4 FALSE)
endif()

if (SPARC_T4)
    message(STATUS "Detected SPARC T4+ (rd %asr26 supported)")
    add_compile_definitions(SPARC_T4)
else()
    message(STATUS "Classic SPARCv9 (no T4+ support)")
endif()
