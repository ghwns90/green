package variable;

public class TestVar01 {

	public static void main(String[] args) {
		
		// 나이 계산
		// 나이 = 올해 연도 - 태어난 연도
		// 올해연도 2025 정수 int
		int thisYear = 2025;
		// 태어난연도
		int birthYear = 1998;
		
		String name = "윈터";
		
		int age = 0;
		age = thisYear - birthYear ;
		System.out.println("이름 : " + name);
		System.out.println("태어난 연도 : " + birthYear);
		System.out.println("나이 : " + age); 

	}

}
