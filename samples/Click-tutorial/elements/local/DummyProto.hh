#ifndef DUMMYPROTO_HH
#define DUMMYPROTO_HH

#define DUMMYPROTO_REQUEST 0
#define DUMMYPROTO_ANSWER 1

#define DUMMY_CLASSIFY_ANNO_OFFSET 4

#define DUMMYPROTO_DATA_LEN 100

#define DUMMYPROTO_LEN_A 1 << 0
#define DUMMYPROTO_LEN_B 1 << 1

struct DummyProto {
#if CLICK_BYTE_ORDER == CLICK_BIG_ENDIAN
  unsigned int T : 1;
  unsigned int Len : 7;
#elif CLICK_BYTE_ORDER == CLICK_LITTLE_ENDIAN
  unsigned int Len : 7;
  unsigned int T : 1;
#else
#error "Undefined Byte Order!"
#endif
  char Data[DUMMYPROTO_DATA_LEN];
} CLICK_SIZE_PACKED_ATTRIBUTE;

#endif