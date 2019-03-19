defmodule PollutionData do
  defp importLinesFromCSV do
    f=File.read!("pollution.csv")
    f=String.split(f,"\n")
    f
  end

  defp oneLine(line) do
    [d,h|t]=String.split(line,",")
    d=Enum.reverse(String.split(d,"-"))
    h=String.split(h,":")
    [d,h|t]
  end

  defp mapList([a,b,c,d,e]) do
    a=Enum.map(fn x -> elem(Integer.parse(x),0) end)
    b=Enum.map(fn x -> elem(Integer.parse(x),0) end)
    c=Integer.parse(c)
    d=Integer.parse(d)
    e=Integer.parse(e)
    [a,b,c,d,e]
  end

  def parseCSV do
    f=importLinesFromCSV()
    for l <- f do l=oneLine(l)
      l=mapList(l)
    end
  end
end