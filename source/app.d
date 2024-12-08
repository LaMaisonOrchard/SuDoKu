import std.stdio;
import SudoKu;

void Read(T)(T map)
{
	Read(stdin, map);
}

void Read(T)(File fp, T map)
{
	ushort index = 0;
	while (index < map.length)
	{
		char ch;
		if (fp.readf!"%c"(ch) == 1)
		{
			if (ch == '*')
			{
				index += 1;
			}
			else if (('1' <= ch) && (ch <= '9'))
			{
				map.Set(index, cast(ushort)(ch - '0'));
				index += 1;
			}
			else if (('A' <= ch) && (ch <= 'G'))
			{
				map.Set(index, cast(ushort)((ch - 'A') + 10U));
				index += 1;
			}
			else if (('a' <= ch) && (ch <= 'g'))
			{
				map.Set(index, cast(ushort)((ch - 'a') + 10U));
				index += 1;
			}
			else
			{
				// Padding char
			}
		}
		else
		{
		}
	}
}


void Write(ushort DIM)(SudoKu.SudoKu!DIM map)
{
	ushort index = 0;
	
	writeln("-------------");
	write("|");
	while (index < map.length)
	{
		write(map.Get(index));
		index += 1;
		if ((index%(DIM*DIM*DIM)) == 0)
		{
			writeln("|");
			writeln("-------------");
			write("|");
		}
		else if ((index%(DIM*DIM)) == 0)
		{
			writeln("|");
			write("|");
			
		}
		else if ((index%DIM) == 0)
		{
			write("|");
		}
	}
}

Result TrialAndError(ushort DIM)(ref SudoKu.SudoKu!DIM map)
{
	for (ushort index = 0U; (index < map.length); index += 1U)
	{
		for (ushort value = 1U; (value <= DIM*DIM); value += 1U)
		{
			if ((map.GetBag(index) & (1U << (value -1U))) != 0U)
			{
				auto next = new SudoKu.SudoKu!3U(map);
				next.Set(index, value);
	
				switch (next.Solve())
				{
					case Result.COMPLETE:
						writeln("COMPLETE!!!");
						map = next;
						return Result.COMPLETE;
						
					case Result.INCOMPLETE:
						writeln("INCOMPLETE :-(");
						auto result = TrialAndError!3U(next);
						if (result == Result.COMPLETE)
						{
							map = next;
						}
						return result;
						
					case Result.ERROR:
						writeln("ERROR :-((");
						break;
						
					default : assert(0);
				}
			}
		}
	}
	
	return Result.ERROR;
}

void main()
{
	auto map = new SudoKu.SudoKu!3U();
	
	Read(map);
	
	auto state = map.Solve();
	
	if (state == Result.INCOMPLETE)
	{
		// Try the trial the error method
		state = TrialAndError!3U(map);
	}
	
	switch (state)
	{
		case Result.COMPLETE:
			writeln("COMPLETE!!!");
			map.Check();
			break;
			
		case Result.INCOMPLETE:
			writeln("INCOMPLETE :-(");
			Debug(map);
			break;
			
		case Result.ERROR:
			writeln("ERROR :-((");
			Debug(map);
			break;
			
		default : assert(0);
	}
	
	Write!3U(map);
}
