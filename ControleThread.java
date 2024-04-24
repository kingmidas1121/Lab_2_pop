package com.company;

import java.util.Random;

public class ControleThread {

  private int stopThreadsCount = 0;
  private final int threadsCount = 8;
  private final int maxArraySize = 10000;

  private int minIndex = 0;
  private int minElement = 0;

  public void EntryPoint(){
    System.out.println("Threads count: " + threadsCount);
    int[] array = new int[maxArraySize];
    CreateRandomValues(array);

    for (int i = 0; i < threadsCount; i++) {
      new СalculationThread(array, i, threadsCount, this).start();
    }
      WaitForThreadsStop();
      System.out.println("Min index: " + minIndex + ", min element: " + minElement);
  }

  synchronized private void WaitForThreadsStop(){
    while (threadsCount > stopThreadsCount) {
      try {
        wait();
      } catch (InterruptedException e) {
        e.printStackTrace();
      }
   }
  }
  synchronized public void CounterStopThreads(int minElement, int minIndex, int threadIndex){
    System.out.println("Thread " + threadIndex + " was ended with min index: " + minIndex + ", min value: " + minElement);

    if (minElement < this.minElement) {
      this.minIndex = minIndex;
      this.minElement = minElement;
    }
    stopThreadsCount++;
    if (threadsCount >= stopThreadsCount) {
      notify();
    }
  }

  private void CreateRandomValues(int[] array) {
    Random random = new Random();
    int randomIndex = random.nextInt(array.length);
    int randomValue = random.nextInt(Integer.MIN_VALUE, 0);
    array[randomIndex] = randomValue;
    System.out.println("Random index is: " + randomIndex + ",min element is: " + randomValue);
  }
}
