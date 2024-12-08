
void toCord(ushort DIM)(ushort index, ref ushort x, ref ushort y)
{
	x = index/(DIM*DIM);
	y = index%(DIM*DIM);
}

ushort toIndex(ushort DIM)(ushort x, ushort y)
{
	return cast(ushort)((x * (DIM*DIM)) + y);
}

ushort bitCount(ushort i)
{
	ushort count = 0;
	
	while (i != 0U)
	{
		count += 1U;
		i = cast(ushort)((i -1U) & i);
	}
	
	return count;
}