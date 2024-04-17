package com.company;

class СalculationThread extends Thread{

  private final ControleThread controleThread;
  private final int[] array;
  private final int threadIndex;
  private final int threadsCount;

  private int minIndex;
  private int minElement;


  public СalculationThread(int[] array, int threadIndex, int threadsCount, ControleThread controleThread) {
    this.array = array;
    this.threadIndex = threadIndex;
    this.threadsCount = threadsCount;
    this.controleThread = controleThread;
  }

  @Override
  public void run() {
    int firstIndex = threadIndex * array.length / threadsCount;
    int lastIndex = (threadIndex + 1) * array.length / threadsCount;
    minIndex = firstIndex;
    minElement = array[firstIndex];
    for (int i = firstIndex; i < lastIndex; i++) {
      if (array[i] < minElement) {
        minElement = array[i];
        minIndex = i;
      }
    }
    controleThread.CounterStopThreads(minElement, minIndex, threadIndex);
  }
}

