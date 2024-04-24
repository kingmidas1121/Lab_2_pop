with Ada.Text_IO; use Ada.Text_IO;
with Ada.Numerics.discrete_Random;
procedure Main is

   dim : constant Integer := 100000;
   thread_num : constant Integer := 5;
   minIndex : Integer;
   minValue : Integer;
   arr : array(1..dim) of Integer;

   function generate_random_number ( from: in Integer; to: in Integer) return Integer is
       subtype Rand_Range is Integer range from .. to;
       package Rand_Int is new Ada.Numerics.Discrete_Random(Rand_Range);
       use Rand_Int;
       gen : Rand_Int.Generator;
       ret_val: Rand_Range;
   begin
      Rand_Int.Reset(gen);
      ret_val := Random(gen);
      return ret_val;
   end;

   procedure GenerateArray is
      rndIndex : Integer;
      rndValue : Integer;
   begin
      for i in 1..dim loop
         arr(i) := 0;
      end loop;

      rndIndex := generate_random_number(0, dim);
      rndValue := generate_random_number(-100, 0);
      arr(rndIndex) := rndValue;
   end GenerateArray;

   task type Thread is
      entry Init(thread_index : in Integer);
   end Thread;

   protected ThreadManager is
      procedure ChangeMin(MinIndex : in Integer; MinValue : in Integer; ThreadIndex : in Integer);
      entry GetMinIndex(MinIndex : out Integer; MinValue : out Integer);
   private
      min_Index : Integer := 1;
      min_Value : Integer := arr(1);
      count_of_threads : Integer;
   end ThreadManager;

   protected body ThreadManager is
      procedure ChangeMin(MinIndex : in Integer; MinValue : in Integer; ThreadIndex : in Integer) is
      begin
         Put_Line("Minimal element in thread" & ThreadIndex'img & ": " & MinValue'img & "  (index" & MinIndex'img & ")");
            if (MinValue < min_Value) then
               min_Value := MinValue;
               min_Index := MinIndex;
            end if;
         count_of_threads := count_of_threads + 1;
      end ChangeMin;

      entry GetMinIndex(MinIndex : out Integer; MinValue : out Integer) when count_of_threads = thread_num is
      begin
         MinIndex := min_Index;
         MinValue := min_Value;
      end GetMinIndex;
   end ThreadManager;

   task body Thread is
      min_index : Integer;
      min_value : Integer;
      start_index, finish_index : Integer;
      thread_index : Integer;
   begin
      accept Init(thread_index : in Integer) do
         Thread.thread_index := thread_index;
      end Init;

      start_index := ((thread_index - 1) * dim / thread_num) + 1;
      finish_index := thread_index * dim / thread_num;
      min_index := start_index;
      min_value := arr(min_index);

      for i in start_index..finish_index loop
         if (arr(i) < min_value) then
            min_index := i;
            min_value := arr(i);
         end if;
      end loop;
      ThreadManager.ChangeMin(min_index, min_value, thread_index);
   end Thread;

   threads : array(1..thread_num) of Thread;

begin
   GenerateArray;
   for i in 1..thread_num loop
      threads(i).Init(i);
   end loop;
   Put_Line("Threads count: " & thread_num'img);
   ThreadManager.GetMinIndex(minIndex, minValue);
   Put_Line("");
   Put_Line("Minimal value: " & minValue'img);
   Put_Line("Index of minimal value: " & minIndex'img);
   end Main;
