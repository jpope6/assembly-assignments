#include <bits/stdc++.h>

using namespace std;

extern "C" double birthday();

int main(int argc, char *argv[]) {
  printf("Welcome to Daylight Sleeping Time brought to you by Jared Pope.\n");
  double ans = birthday();
  printf("The main function has received this number %lf and will keep it for future reference.\n", ans);
  printf("A zero will be sent to the Operating System.  Bye.\n");
  return 0;
}
