# JAVA BASIC

What is main in Java? 
Can there be multiple main methods in java application?
```java
public class Main {
    public static void main(String[] args) {
        System.out.println("Hello World!");
    }
}
```
`main()` is a default signature predefined in the JVM that to execute a program line by line and end the execution after completion of this method. In another world, the `main()` method is the entry point of the application. 

`String[] args` in Java is an array of strings which store *arguments* passed by command line while starting the program. All the command line arguments are stored in that array. 

CAN THERE BE MULTIPLE MAIN IN JAVA?
```java
public class Main {
    public static void main(String[] args) {
        System.out.println("Hello World!");
    }

    public static void main(Integer[] args) {
        System.out.println("Hello World!");
    }
}
```