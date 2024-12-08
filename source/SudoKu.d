import std.stdio;
import std.format;
import Utils;

private
{
	struct SudoKuRow(ushort DIM)
	{
		this(SudoKu!DIM map, ushort x)
		{
			this.map = map;
			this.x = x;
		}
		
		void Clear(ushort mask)
		{
			for (ushort y = 0U; (y < (DIM*DIM)); y += 1U)
			{
				this.map.Clear(toIndex!DIM(this.x, y), mask);
			}
		}
		
		void CheckBag()
		{
			for (ushort y = 0U; (y < (DIM*DIM)); y += 1U)
			{
				this.map.CheckBag(toIndex!DIM(this.x, y));
			}
		}
		
		@property ushort length() {return DIM*DIM;}
		
		ushort opIndex(ushort index)
		{
			return map.GetBag(toIndex!DIM(this.x, index));
		}
		
		ushort Value(ushort index)
		{
			return map.GetValue(toIndex!DIM(this.x, index));
		}
		
		void SetValue(ushort index, ushort value)
		{
			return map.Set(toIndex!DIM(this.x, index), value);
		}
		
		void SetBag(ushort index, ushort mask)
		{
			map.SetBag(toIndex!DIM(this.x, index), mask);
		}
		
		SudoKu!DIM map;
		ushort x;
	}

	struct SudoKuCol(ushort DIM)
	{
		this(SudoKu!DIM map, ushort y)
		{
			this.map = map;
			this.y = y;
		}
		
		void Clear(ushort mask)
		{
			for (ushort x = 0U; (x < (DIM*DIM)); x += 1U)
			{
				this.map.Clear(toIndex!DIM(x, this.y), mask);
			}
		}
		
		void CheckBag()
		{
			for (ushort x = 0U; (x < (DIM*DIM)); x += 1U)
			{
				this.map.CheckBag(toIndex!DIM(x, this.y));
			}
		}
		
		@property ushort length() {return DIM*DIM;}
		
		ushort opIndex(ushort index)
		{
			return map.GetBag(toIndex!DIM(index, this.y));
		}
		
		ushort Value(ushort index)
		{
			return map.GetValue(toIndex!DIM(index, this.y));
		}
		
		void SetValue(ushort index, ushort value)
		{
			return map.Set(toIndex!DIM(index, this.y), value);
		}
		
		void SetBag(ushort index, ushort mask)
		{
			map.SetBag(toIndex!DIM(index, this.y), mask);
		}
		
		SudoKu!DIM map;
		ushort y;
	}

	struct SudoKuBlock(ushort DIM)
	{
		this(SudoKu!DIM map, ushort index)
		{
			this.map = map;
			
			ushort x;
			ushort y;
			toCord!DIM(index, x, y);
			
			this.x = x/DIM;
			this.y = y/DIM;
		}
		
		this(SudoKu!DIM map, ushort x, ushort y)
		{
			this.map = map;
			
			this.x = x;
			this.y = y;
		}
		
		void Clear(ushort mask)
		{
			for (ushort x = 0U; (x < DIM); x += 1U)
			{
				for (ushort y = 0U; (y < DIM); y += 1U)
				{
					this.map.Clear(toIndex!DIM(cast(ushort)((this.x * DIM) + x), cast(ushort)((this.y * DIM) + y)), mask);
				}
			}
		}
		
		void CheckBag()
		{
			for (ushort x = 0U; (x < DIM); x += 1U)
			{
				for (ushort y = 0U; (y < DIM); y += 1U)
				{
					this.map.CheckBag(toIndex!DIM(cast(ushort)((this.x * DIM) + x), cast(ushort)((this.y * DIM) + y)));
				}
			}
		}
		
		@property ushort length() const {return DIM*DIM;}
		@property ushort side()   const {return DIM;}
		@property string posn()   const {return format("(%d, %d)", this.x, this.y);}
		
		ushort opIndex(ushort index)
		{
			ushort x = index/DIM;
			ushort y = index%DIM;
			return opIndex(x, y);
		}
		
		ushort opIndex(ushort x, ushort y)
		{
			return map.GetBag(toIndex!DIM(cast(ushort)((this.x * DIM) + x), cast(ushort)((this.y * DIM) + y)));
		}
		
		ushort Value(ushort index)
		{
			ushort x = index/DIM;
			ushort y = index%DIM;
			return map.GetValue(toIndex!DIM(cast(ushort)((this.x * DIM) + x), cast(ushort)((this.y * DIM) + y)));
		}
		
		void SetValue(ushort index, ushort value)
		{
			ushort x = index/DIM;
			ushort y = index%DIM;
			return map.Set(toIndex!DIM(cast(ushort)((this.x * DIM) + x), cast(ushort)((this.y * DIM) + y)), value);
		}
		
		void SetBag(ushort index, ushort mask)
		{
			ushort x = index/DIM;
			ushort y = index%DIM;
			SetBag(x, y, mask);
		}
		
		void SetBag(ushort x, ushort y, ushort mask)
		{
			map.SetBag(toIndex!DIM(cast(ushort)((this.x * DIM) + x), cast(ushort)((this.y * DIM) + y)), mask);
		}
		
		SudoKuBlock!DIM NextRight()
		{
			return SudoKuBlock!DIM(map, x, cast(ushort)((y+1)%DIM));
		}
		
		SudoKuBlock!DIM NextDown()
		{
			return SudoKuBlock!DIM(map, cast(ushort)((x+1)%DIM), y);
		}
		
		SudoKu!DIM map;
		ushort x;
		ushort y;
	}
}


enum Result
{
	COMPLETE,
	INCOMPLETE,
	ERROR
};

class SudoKu(ushort DIM)
{
	this()
	{
	}
		
	this(const SudoKu!DIM other)
	{
		this.board = other.board;
	}
		
	@property ushort length() {return DIM*DIM*DIM*DIM;}
	
	void Set(ushort index, ushort num)
	{
		assert(num >0);
		assert(num <= DIM*DIM);
		ushort value = cast(ushort)(1U<<(num-1U));
		
		ushort x;
		ushort y;
		toCord!DIM(index, x, y);
		
		if ((value & (board[index].bag | board[index].value)) == 0U)
		{
			this.error = true;
			writeln("Illegal entry (", (x+1), ",", (y+1), ") = ", num);
		}
		
		if (board[index].value == value)
		{
			// Already set
		}
		else if (board[index].value != 0U)
		{
			this.error = true;
			writeln("Illegal entry (", (x+1), ",", (y+1), ") = ", num, " [", board[index].value, "]");
		}
		else
		{
			this.updated = true;
		
			board[index].value = value;
			board[index].bag = 0U;
			
			SudoKuBlock!DIM block = SudoKuBlock!DIM(this, index);
			SudoKuRow!DIM   row   = SudoKuRow!DIM(this, x);
			SudoKuCol!DIM   col   = SudoKuCol!DIM(this, y);
			
			// Needs to be breadth first!!!
			block.Clear(cast(ushort)(~value));
			row  .Clear(cast(ushort)(~value));
			col  .Clear(cast(ushort)(~value));
			
			block.CheckBag();
			row  .CheckBag();
			col  .CheckBag();
		}
	}
	
	char Get(ushort index)
	{
		switch(board[index].value)
		{
			case 0x0001U: return '1';
			case 0x0002U: return '2';
			case 0x0004U: return '3';
			case 0x0008U: return '4';
			case 0x0010U: return '5';
			case 0x0020U: return '6';
			case 0x0040U: return '7';
			case 0x0080U: return '8';
			case 0x0100U: return '9';
			case 0x0200U: return 'A';
			case 0x0400U: return 'B';
			case 0x0800U: return 'C';
			case 0x1000U: return 'D';
			case 0x2000U: return 'E';
			case 0x4000U: return 'F';
			case 0x8000U: return 'G';
			default: return '*';
		}
	}
	
	Result Solve()
	{
		int tick = 1;
		while (this.updated && !this.error)
		{
			this.updated = false;
			
			writeln("Tick ", tick);
			tick += 1;
			
			// Logic
			for (ushort i = 0; (i <(DIM*DIM)); i += 1U)
			{
				SudoKuRow!DIM row = SudoKuRow!DIM(this, i);
				SudoKuCol!DIM col = SudoKuCol!DIM(this, i);
				
				OnlyOne(row);
				OnlyOne(col);
			}
			
			for (ushort x = 0; (x < DIM); x += 1U)
			{
				for (ushort y = 0; (y <DIM); y += 1U)
				{
					SudoKuBlock!DIM block = SudoKuBlock!DIM(this, x, y);
					
					OnlyOne(block);
					ExclusiveLine(block);
				}
			}
			
			for (ushort i = 0; (i <(DIM*DIM)); i += 1U)
			{
				SudoKuRow!DIM row = SudoKuRow!DIM(this, i);
				SudoKuCol!DIM col = SudoKuCol!DIM(this, i);
				
				ExclusivePair(row);
				ExclusiveTriple(row);
				ExclusiveQuad(row);
				
				ExclusivePair(col);
				ExclusiveTriple(col);
				ExclusiveQuad(col);
			}
			
			for (ushort x = 0; (x < DIM); x += 1U)
			{
				for (ushort y = 0; (y <DIM); y += 1U)
				{
					SudoKuBlock!DIM block = SudoKuBlock!DIM(this, x, y);
					
					ExclusivePair(block);
					ExclusiveTriple(block);
					ExclusiveQuad(block);
				}
			}			
		}
		
		if (this.error)
		{
			return Result.ERROR;
		}
		else if (AreAllSet())
		{
			return Result.COMPLETE;
		}
		else
		{
			return Result.INCOMPLETE;
		}
	}
	
	void Check()
	{
		for (ushort i = 0; (i <(DIM*DIM)); i += 1U)
		{
			SudoKuRow!DIM row = SudoKuRow!DIM(this, i);
			SudoKuCol!DIM col = SudoKuCol!DIM(this, i);
			
			if (!Check(row))
			{
				writeln("Row ", (i+1U), " Invalid");
			}
			if (!Check(col))
			{
				writeln("Col ", (i+1U), " Invalid");
			}
		}
		
		for (ushort x = 0; (x < DIM); x += 1U)
		{
			for (ushort y = 0; (y <DIM); y += 1U)
			{
				SudoKuBlock!DIM block = SudoKuBlock!DIM(this, x, y);
				
				if (!Check(block))
				{
					writeln("Blk (", (x+1U), ", ", (y+1U), ") Invalid");
				}
			}
		}
	}
	
	string GetBagValue(ushort index)  // For debug only
	{
		return format("%03X", board[index].bag);
	}
		
	ushort GetBag(ushort index)
	{
		return board[index].bag;
	}
		
	private
	{
		void Clear(ushort index, ushort mask)
		{
			auto current = bitCount(board[index].bag);
			auto next = bitCount(mask);
			auto diff = bitCount(board[index].bag^mask);
			
			if (board[index].bag != (board[index].bag & mask))
			{
				this.updated = true;
				board[index].bag &= mask;
			}
			
			if ((board[index].bag | board[index].value) == 0U)
			{
				this.error = true;
			}
		}
		
		void CheckBag(ushort index)
		{
			if (bitCount(board[index].bag) == 1U)
			{
				this.Set(index, MapValue(board[index].bag));
			}
		}
		
		ushort GetValue(ushort index)
		{
			return board[index].value;
		}
		
		void SetBag(ushort index, ushort mask)
		{
			Clear(index, mask);
			CheckBag(index);
		}
		
		ushort MapValue(ushort mask)
		{
			switch(mask)
			{
				case 0x0001U: return 1U;
				case 0x0002U: return 2U;
				case 0x0004U: return 3U;
				case 0x0008U: return 4U;
				case 0x0010U: return 5U;
				case 0x0020U: return 6U;
				case 0x0040U: return 7U;
				case 0x0080U: return 8U;
				case 0x0100U: return 9U;
				case 0x0200U: return 10U;
				case 0x0400U: return 11U;
				case 0x0800U: return 12U;
				case 0x1000U: return 13U;
				case 0x2000U: return 14U;
				case 0x4000U: return 15U;
				case 0x8000U: return 16U;
				default: 
					this.error = true;
					writeln("Illegal map ", format("03X", mask));
					return 0;
			}
		}
		
		void OnlyOne(T)(T set)
		{
			for (ushort i = 0U; (i < set.length); i += 1U)
			{
				ushort mask  = cast(ushort)(1 << i);
				ushort count = 0U;
				for (ushort j = 0U; (j < set.length); j += 1U)
				{
					if ((set[j]&mask) != 0U)
					{
						count += 1U;
					}
				}
						
				if (count == 1)
				{
					for (ushort k = 0U; (k < set.length); k += 1U)
					{
						if ((set[k]&mask) != 0U)
						{
							set.SetValue(k, cast(ushort)(i+1U));
						}
					}
				}
			}
		}
		
		
		void ExclusiveLine(T)(T set)
		{
			for (ushort x = 0U; (x < set.side); x += 1U)
			{
				// Possible in row
				ushort mask1 = 0U;
				ushort mask2 = 0U;
				for (ushort y = 0U; (y < set.side); y += 1U)
				{
					mask1 |= set[x,y];
					mask2 |= set[y,x];
				}
				
				for (ushort x2 = 0U; (x2 < set.side); x2 += 1U)
				{
					if (x != x2)
					{
						for (ushort y = 0U; (y < set.side); y += 1U)
						{
							mask1 &= cast(ushort)(~set[x2,y]);
							mask2 &= cast(ushort)(~set[y,x2]);
						}
					}
				}
				if (mask1 != 0U)
				{
					//writeln("Clear X ", set.posn, " ", x, "[", format("%03X", mask1), "]");
					T next = set;
					for (ushort blk = 0U; (blk < (set.side-1U)); blk += 1U)
					{
						next = next.NextRight();
						for (ushort y = 0U; (y < set.side); y += 1U)
						{
							next.SetBag(x, y, cast(ushort)(next[x,y] & ~mask1));
						}
					}
				}
				if (mask2 != 0U)
				{
					//writeln("Clear Y ", set.posn, " ", x, "[", format("%03X", mask2), "]");
					T next = set;
					for (ushort blk = 0U; (blk < (set.side-1U)); blk += 1U)
					{
						next = next.NextDown();
						for (ushort y = 0U; (y < set.side); y += 1U)
						{
							next.SetBag(y, x, cast(ushort)(next[y,x] & ~mask2));
						}
					}
				}
			}
		}
		
		
		
		void ExclusivePair(T)(T set)
		{
			for (ushort first = 0U; (first < (set.length -1U)); first += 1U)
			{
				for (ushort second = cast(ushort)(first+1U); (second < set.length); second += 1U)
				{
					ushort mask = 0U;
					mask |= (1U << first);
					mask |= (1U << second);
					
					ushort count1 = 0U;
					ushort count2 = 0U;
					ushort count3 = 0U;
					for (ushort index = 0U; (index < set.length); index += 1U)
					{
						if ((set[index] & mask) == mask)
						{
							count1 += 1U;
						}
						if ((set[index] & mask) != 0U)
						{
							count2 += 1U;
						}
						if (set[index] == mask)
						{
							count3 += 1U;
						}
					}
					
					if ((count1 == 2U) && (count2 == 2))
					{
						for (ushort index = 0U; (index < set.length); index += 1U)
						{
							if ((set[index] & mask) == mask)
							{
								set.SetBag(index, mask);
							}
						}
					}
					
					if (count3 == 2U)
					{
						for (ushort index = 0U; (index < set.length); index += 1U)
						{
							if (set[index] != mask)
							{
								set.SetBag(index, cast(ushort)(set[index] & ~mask));
							}
						}
					}
				}
			}
		}
		
		
		void ExclusiveTriple(T)(T set)
		{
			for (ushort first = 0U; (first < (set.length -2U)); first += 1U)
			{
				for (ushort second = cast(ushort)(first+1U); (second < (set.length-1U)); second += 1U)
				{
					for (ushort third = cast(ushort)(second+1U); (third < set.length); third += 1U)
					{
						ushort mask = 0U;
						mask |= (1U << first);
						mask |= (1U << second);
						mask |= (1U << third);
						
						ushort count1 = 0U;
						ushort count2 = 0U;
						ushort count3 = 0U;
						for (ushort index = 0U; (index < set.length); index += 1U)
						{
							if ((set[index] & mask) == mask)
							{
								count1 += 1U;
							}
							if ((set[index] & mask) != 0U)
							{
								count2 += 1U;
							}
							if (set[index] == mask)
							{
								count3 += 1U;
							}
						}
						
						if ((count1 == 3U) && (count2 == 3))
						{
							for (ushort index = 0U; (index < set.length); index += 1U)
							{
								if ((set[index] & mask) == mask)
								{
									set.SetBag(index, mask);
								}
							}
						}
						
						if (count3 == 3U)
						{
							for (ushort index = 0U; (index < set.length); index += 1U)
							{
								if (set[index] != mask)
								{
									set.SetBag(index, cast(ushort)(set[index] & ~mask));
								}
							}
						}
					}
				}
			}
		}
		
		
		void ExclusiveQuad(T)(T set)
		{
			for (ushort first = 0U; (first < (set.length -3U)); first += 1U)
			{
				for (ushort second = cast(ushort)(first+1U); (second < (set.length-2U)); second += 1U)
				{
					for (ushort third = cast(ushort)(second+1U);  (third < (set.length-1U)); third += 1U)
					{
						for (ushort fourth = cast(ushort)(third+1U); (fourth < set.length); fourth += 1U)
						{
							ushort mask = 0U;
							mask |= (1U << first);
							mask |= (1U << second);
							mask |= (1U << third);
							mask |= (1U << fourth);
							
							ushort count1 = 0U;
							ushort count2 = 0U;
							ushort count3 = 0U;
							for (ushort index = 0U; (index < set.length); index += 1U)
							{
								if ((set[index] & mask) == mask)
								{
									count1 += 1U;
								}
								if ((set[index] & mask) != 0U)
								{
									count2 += 1U;
								}
								if (set[index] == mask)
								{
									count3 += 1U;
								}
							}
							
							if ((count1 == 4U) && (count2 == 4U))
							{
								for (ushort index = 0U; (index < set.length); index += 1U)
								{
									if ((set[index] & mask) == mask)
									{
										set.SetBag(index, mask);
									}
								}
							}
							
							if (count3 == 4U)
							{
								for (ushort index = 0U; (index < set.length); index += 1U)
								{
									if (set[index] != mask)
									{
										set.SetBag(index, cast(ushort)(set[index] & ~mask));
									}
								}
							}
						}
					}
				}
			}
		}
		
		bool Check(T)(T set)
		{
			ushort valid = cast(ushort)((1U << set.length) -1U);
			ushort check = 0U;
			
			for (ushort i = 0U; (i < set.length); i += 1U)
			{
				check |= set.Value(i);
			}
			
			return (check == valid);
		}
		
		bool AreAllSet()
		{
			for (ushort i = 0U; (i < DIM*DIM*DIM*DIM); i += 1U)
			{
				if (this.board[i].value == 0U)
				{
					return false;
				}
			}
			
			return true;
		}
		
		struct entry
		{
			ushort value = 0U;
			ushort bag = 0x01FFU;
		};
		
		entry[DIM*DIM*DIM*DIM] board;
		bool error   = false;
		bool updated = false;
	}
}




void Debug(ushort DIM)(SudoKu!DIM map)
{
	ushort index = 0;
	writeln("--------------------------------------");
	while (index < map.length)
	{
		write(map.GetBagValue(index), ":");
		index += 1;
		if ((index%(DIM*DIM*DIM)) == 0)
		{
			writeln();
			writeln("--------------------------------------");
		}
		else if ((index%(DIM*DIM)) == 0)
		{
			writeln();
			
		}
		else if ((index%DIM) == 0)
		{
			write("|");
		}
	}
}
