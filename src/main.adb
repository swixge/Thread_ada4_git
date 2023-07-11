with Ada.Text_IO; use Ada.Text_IO;
with Ada.Calendar; use Ada.Calendar;
with GNAT.Semaphores; use GNAT.Semaphores;

procedure main is
   task type Philosopher is
      entry Start(Id : Integer);
   end Philosopher;

   Forks : array (1..5) of Counting_Semaphore(1, Default_Ceiling);

   Philosophers : array (1..5) of Philosopher;

   procedure Lock_Forks(Id : Integer) is
   begin
      if Id mod 2 = 0 then
         Forks(Id).Seize;
         Forks(Id + 1).Seize;
      else
         Forks(Id + 1).Seize;
         Forks(Id).Seize;
      end if;

      Put_Line("Philosopher " & Id'Img & " took left fork");
      Put_Line("Philosopher " & Id'Img & " took right fork");
   end Lock_Forks;

   procedure Unlock_Forks(Id : Integer) is
   begin
      Forks(Id).Release;
      Forks(Id + 1).Release;
      Put_Line("Philosopher " & Id'Img & " put left fork");
      Put_Line("Philosopher " & Id'Img & " put right fork");
   end Unlock_Forks;

   task body Philosopher is
      Id : Integer;
      Locked : Boolean := False;
   begin
      accept Start(Id : in Integer) do
         Philosopher.Id := Id;
      end Start;

      for I in 1..5 loop
         Put_Line("Philosopher " & Id'Image & " is thinking");

         Lock_Forks(Id);

         Put_Line("Philosopher " & Id'Image & " is eating");
         delay 0.2;

         Unlock_Forks(Id);
      end loop;
   end Philosopher;

begin
   for I in Philosophers'Range loop
      Philosophers(I).Start(I);
   end loop;

   for I in Philosophers'Range loop
      null;
   end loop;
end main;

