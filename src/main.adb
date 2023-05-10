with Ada.Text_IO; use Ada.Text_IO;
with GNAT.Semaphores; use GNAT.Semaphores;

procedure main is
   task type Philosopher is
      entry Start(Id : Integer);
   end Philosopher;

   Forks : array (1..5) of Counting_Semaphore(1, Default_Ceiling);
task body Philosopher is
      Id : Integer;
      Id_Left_Fork, Id_Right_Fork : Integer;
   begin
      accept Start (Id : in Integer) do
         Philosopher.Id := Id;
         Id_Left_Fork := Id;
         Id_Right_Fork := Id rem 5 + 1;
         if(Id=5) then
            Id_Right_Fork:=5;
              Id_Left_Fork:=1;
         end if;

      end Start;
         for I in 1..5 loop
            Put_Line("Philosopher " & Id'Img & " thinking " & I'Img & " time");
            Forks(Id_Left_Fork).Seize;
            Put_Line("Philosopher " & Id'Img & " took left fork");
            Forks(Id_Right_Fork).Seize;
         Put_Line("Philosopher " & Id'Img & " took right fork");
         delay(Standard.Duration(0.2));
            Put_Line("Philosopher " & Id'Img & " eating " & I'Img & " time");
            Forks(Id_Right_Fork).Release;
            Put_Line("Philosopher " & Id'Img & " put right fork");
            Forks(Id_Left_Fork).Release;
            Put_Line("Philosopher " & Id'Img & " put left fork");
         end loop;
      end Philosopher;

      Philosophers : array (1..5) of Philosopher;

      begin
         for I in Philosophers'Range loop
            Philosophers(I).Start(I);
         end loop;
      end main;
