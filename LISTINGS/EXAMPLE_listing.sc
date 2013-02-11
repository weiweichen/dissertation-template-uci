import "A";
import "B";

behavior Main()
{
  A a;
  B b;
  
  void main(void)
  {
    par {
      a.main();
      b.main();
    }
  }
};
