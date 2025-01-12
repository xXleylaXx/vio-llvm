#define NULL ((void *)0)

#include "zor.h"

extern int malloc(unsigned long);
extern int printf(const char * format, ...);

struct CodeFunction {
    struct CodeFunction* previous;
    char* name;
    long  execIndex;
    long  size;
};

struct CodeObject {
    struct CodeObject* previous;
    struct CodeObject* next;
    struct CodeObject* first;
    char* name;
    void* afunc;
    void* bfunc;
    long* pointer;
    long  size;
    struct CodeFunction* functionsHead;
};

static struct CodeObject* head = NULL;
static struct CodeObject* tail = NULL;
static struct CodeObject* middle = NULL;

__attribute__((used, noinline)) void addCodeObject(char name[], long* pointer, long size) {
    //allocate new List Element
    struct CodeObject* newObject = (struct CodeObject*) alci(sizeof(struct CodeObject));

    // Initialize the new Element
    newObject->name = name;
    newObject->pointer = pointer;
    newObject->previous = head;
    newObject->next = tail;
    newObject->first = middle;
    newObject->functionsHead = NULL;
    newObject->afunc = &malloc;
    newObject->bfunc = &printf;

    // Update the head to point to the new Element
    head = newObject;
    tail = newObject;
    middle = newObject;
}

/*
__attribute__((used, noinline)) void registerFunction(struct CodeObject* parent, char name[], long index, long size) {
    //allocate new List Element
    //struct CodeFunction* newFunction = (struct CodeFunction*)malloc(sizeof(struct CodeFunction));

    // Initialize the new Element
    newFunction->name = name;
    newFunction->execIndex = index;
    newFunction->size = size;
    newFunction->previous = parent->functionsHead;

    // Update the head to point to the new Element
    parent->functionsHead = newFunction;
}

*/