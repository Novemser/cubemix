import java.util.Arrays;
import java.util.List;

public class GetInfo {
    public static void main(String args[]) {
        String input = "{method=listObject,args=[buck_no_1，buck_no_2],data=nil}";
//        System.out.println(input.indexOf("method="));
        Integer methodStart = input.indexOf("method=") + "method=".length();

        Integer argsStart = input.indexOf("args=") + "args=".length();

        Integer dataStart = input.indexOf("data=") + "data=".length();


        System.out.println(input.substring(methodStart, argsStart - "args=".length() - 1));
        System.out.println(input.substring(argsStart, dataStart - "data=".length()-1));
        System.out.println(input.substring(dataStart, input.length() - 1));

        //        System.out.println(argsStart);
//        System.out.println(dataStart);

        //        System.out.println(input.indexOf("args="));
//        System.out.println(input.indexOf("data="));

//        System.out.println(methodName);
//        System.out.println(inputArgs);
//        System.out.println(Inputdata);

    }
}
