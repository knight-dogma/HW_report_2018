#include <stdio.h>
#include <x86intrin.h>
void swap(int *a, int*b){
  int c;
  c = *a;
  *a = *b;
  *b = c;
}

void put(int start, int counter, int peak, int memory[4][3]){
  for(int i = 0; i < 4; i++){
    if(memory[i][2] < peak){
      swap(&(memory[i][0]), &start);
      swap(&(memory[i][1]), &counter);
      swap(&(memory[i][2]), &peak);
    } else if(memory[i][2] == peak){
      if(memory[i][1] < counter) {
        swap(&(memory[i][0]), &start);
        swap(&(memory[i][1]), &counter);
      }
      break;
    }
  }
}

void climb(int i, int memory[4][3]) {
  int start = i;
  int counter = 0;
  int peak = i;
  while(i > 1) {
    if(i % 2 == 0) {
      i = i / 2;
      counter++;
    } else {
      i = 3 * i + 1;
      if(i > peak) peak = i;
      counter++;
    }
  }
  put(start, counter, peak, memory);
}

int main() {
  int memory[4][3] = { {0} };
  long long ts0 = _rdtsc();
  for(int i = 0; i < 512; i++){
    climb(2 * i + 1, memory);
  }
  long long ts1 = _rdtsc();
  long long dt = ts1 - ts0;
  printf("clocks: %lld\n", dt);
  for(int i = 0; i < 4; i++){
    printf("start: %d\n", memory[i][0]);
    printf("counter: %d\n", memory[i][1]);
    printf("peak: %d\n", memory[i][2]);
  }
  return 0;
}
