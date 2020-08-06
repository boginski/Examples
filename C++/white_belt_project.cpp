#include <exception>
#include <iostream>
#include <iomanip>
#include <vector>
#include <map>
#include <set>

using namespace std;

vector <string> GetCommand(const string& command)
{
	vector <string> answer;
	string buffer;
	for (int i = 0; i < command.size(); i++)
	{
		if (command[i] != ' ')
		{
			buffer += command[i];
		}
		else
		{
			answer.push_back(buffer);
			buffer = "";
		}
	}
	if (buffer != "")
	{
		answer.push_back(buffer);
	}
	return answer;
}

class Date
{
public:
	Date(const int& new_year, const int& new_month, const int& new_day)
	{
		Year = new_year;
		Month = new_month;
		Day = new_day;
	}
	int GetYear() const
	{
		return Year;
	}
	int GetMonth() const
	{
		return Month;
	}
	int GetDay() const
	{
		return Day;
	}
private:
	int Year;
	int Month;
	int Day;
};

Date GetDate(const string& data)
{
	int year, month, day;
	int i = 0, j = 0;
	string buff_y, buff_m, buff_d;
	string acc = "0123456789-+";
	set <char> accept;
	for (auto a : acc)
	{
		accept.insert(a);
	}
	try
	{
	while (i < data.size() && (data[i] != '-' || i == j))
	{
		buff_y += data[i];
		if (accept.count(data[i]) == 0)
		{
			throw exception();
		}
		i++;
	}
	j = ++i;
	while (i < data.size() && (data[i] != '-' || i == j))
	{
		buff_m += data[i];
		if (accept.count(data[i]) == 0)
		{
			throw exception();
		}
		i++;
	}
	j = ++i;
	while (i < data.size() && (data[i] != '-' || i == j))
	{
		buff_d += data[i];
		if (accept.count(data[i]) == 0)
		{
			throw exception();
		}
		i++;
	}

		year = stoi(buff_y);
		month = stoi(buff_m);
		day = stoi(buff_d);
		if (month < 1 or month > 12)
		{
			throw 2;
		}
		else if (day < 1 or day > 31)
		{
			throw 3;
		}
		else
		{
			return Date(year, month, day);
		}
	}
	catch (const int e)
	{
		if (e == 2)
		{
			cout << "Month value is invalid: " + to_string(month) << endl;
			throw 2;
		}
		if (e == 3)
		{
			cout << "Day value is invalid: " + to_string(day) << endl;
			throw 3;
		}
	}

	catch (const exception& e)
	{
		cout << "Wrong date format: " << data << endl;
		throw e;
	}
}

bool operator<(const Date& lhs, const Date& rhs)
{
	bool year, year_equal, month, month_equal, day;
	year = lhs.GetYear() < rhs.GetYear();
	year_equal = lhs.GetYear() == rhs.GetYear();
	month = lhs.GetMonth() < rhs.GetMonth();
	month_equal = lhs.GetMonth() == rhs.GetMonth();
	day = lhs.GetDay() < rhs.GetDay();

	if (year ||
		(year_equal && month) ||
		(year_equal && month_equal && day))
	{
	return true;
	}
	else
	{
	return false;
	}
}

class Database
{
public:
	void AddEvent(const Date& date, const string& event)
	{
		events[date].insert(event);
	}
	bool DeleteEvent(const Date& date, const string& event)
	{
		for (auto& i : events[date])
		{
			if (i == event)
			{
				events[date].erase(event);
				if (events[date].size() == 0)
				{
					events.erase(date);
				}
				return true;
			}
		}
		return false;
	}
	int  DeleteDate(const Date& date)
	{
		int count = events[date].size();
		events.erase(date);
		return count;
	}
	void Find(const Date& date) const
	{
		if (events.count(date) > 0) {
		    set <string> value = events.at(date);
		    for (const auto& v : value)
		    {
		    	cout << v << endl;
		    }
		}
	}
	void Print() const
	{
		for (const auto& data : events)
		{
			for (const auto& event: data.second)
			{
				cout << setfill('0') << setw(4) << data.first.GetYear();
				cout << "-";
				cout << setfill('0') << setw(2) << data.first.GetMonth();
				cout << "-";
				cout << setfill('0') << setw(2) << data.first.GetDay();
				cout << " ";
				cout << event;
				cout << endl;
			}
		}
	}
private:
	map <Date, set <string> > events;
};

int main()
{
	Database db;
	string command;

	while (getline(cin, command))
	{
		if (command != "")
		{
			try
			{
			vector <string> TrueCommand = GetCommand(command);
			//for (int i = 0; i < TrueCommand.size(); i++)
			//{
			//	cout << TrueCommand[i] << endl;
			//}
			if (TrueCommand[0] == "Add")
			{
				Date dt = GetDate(TrueCommand[1]);
				db.AddEvent(dt, TrueCommand[2]);
			}
			else if (TrueCommand[0] == "Del")
			{
				if (TrueCommand.size() == 2)
				{
					Date dt = GetDate(TrueCommand[1]);
					cout << "Deleted " << db.DeleteDate(dt) <<  " events" << endl;
				}
				else if (TrueCommand.size() == 3)
				{
					Date dt = GetDate(TrueCommand[1]);
					if (db.DeleteEvent(dt, TrueCommand[2]))
					{
						cout << "Deleted successfully" << endl;
					}
					else
					{
						cout << "Event not found" << endl;
					}
				}
			}
			else if (TrueCommand[0] == "Find")
			{
				Date dt = GetDate(TrueCommand[1]);
				db.Find(dt);
			}
			else if (TrueCommand[0] == "Print")
			{
				db.Print();
			}
			else
			{
				cout << "Unknown command: " << TrueCommand[0] << endl;
			}
			}
			catch(exception& e)
			{
			}
			catch(int& e)
			{
			}
			}
	}
	return 0;
}
