#include <jni.h>
#include <string>


#include <libqalculate/qalculate.h>

MathStructure *mstruct, *parsed_mstruct, mstruct_exact, prepend_mstruct;

extern "C" JNIEXPORT jstring JNICALL
Java_com_mrkenhoff_libqalculate_MainActivity_stringFromJNI(
        JNIEnv* env,
        jobject /* this */) {


    std::string hello = "Hello from C++";
    return env->NewStringUTF(hello.c_str());
}