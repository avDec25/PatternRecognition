#include <bits/stdc++.h>
using namespace std;

int main(int argc, char const *argv[])
{
	ofstream x_out, y_out,count;
	x_out.open ("a_x.txt");
	y_out.open ("a_y.txt");
	count.open ("count_a.txt");

	int f1;
	string f2;
	int n = 0;
	while(cin >> f1 >> f2 >> n) 
	{
		for (int i = 0; i < n; ++i)
		{
			float x, y;
			cin >> x >> y;

			x_out << x << "\n" ;
			y_out << y << "\n" ;
		}
		count << n <<"\n";
	}

	return 0;
}
