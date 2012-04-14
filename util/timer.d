/**
 * Authors: Felix Hufnagel
 * Copyright: Felix Hufnagel
 * License: http://www.boost.org/LICENSE_1_0.txt
 */
module util.timer;
@system:

import util.array;
import std.datetime;

alias ulong Timestamp;
alias Timestamp Timespan;

///
Timestamp t(){return 100;}
///
alias t curSysTime;

///To use the timer, inherit ITimerManager AND mixin TimerManager
interface ITimerManager
{
	void updateTimers();
	Timer createTimer(void delegate(Timespan) callback, Timespan timeDiff, uint triggerCount);
	void destroyTimer(ITimer t);
}

///
mixin template TimerManager()
{
public:
	///
	void updateTimers()
	{
		foreach(ITimer t; this.timers)
		{
			t.update(curSysTime);
		}
	}
	
	///timediff 0 triggers each update; triggercount = 1 triggers once
	Timer createTimer(void delegate(Timespan) callback, Timespan timeDiff = 0, uint triggerCount = 1)
	{
		Timer timer = new Timer(this, callback, timeDiff, triggerCount);
		this.timers ~= timer;
		return timer;
	}
	
	///
	void destroyTimer(ITimer t)
	{
		t.removeCallback();
		uint pos;
		for(int i=0; i<this.timers.length; ++i)
		{
			if(t is this.timers[i])
				pos = i;
		}
		if(pos < this.timers.length)
		{
			if (pos !=  this.timers.length - 1)
			this.timers[pos] =  this.timers[ this.timers.length - 1];
			this.timers.length =  this.timers.length -1;
		}
	}
	
	///
	void destroyAllTimers()
	{
		foreach(ITimer t; this.timers)
		{
			this.destroyTimer(t);
		}
	}
	
private:	
	ITimer[] timers;
}

///
interface ITimer
{
	///
	void destroy();
	///
	void removeCallback();
	///
	void update(Timestamp now);
}

///Timer triggers the callback every timeDiff milliseconds, triggerCount times. if triggerCount == 0 it triggers until destroy is called
class Timer : ITimer
{
public:
	///
	this(ITimerManager timerManager, void delegate(Timespan) callback, Timespan timeDiff, uint triggerCount)
	{
		this.timerManager = timerManager;
		this.callback = callback;
		this.startTime = curSysTime;
		this.triggerTime = this.startTime + timeDiff;
		this.triggerCount = triggerCount;
	}
	
	///
	~this()
	{
		this.destroy();
	}
	
public:
	///
	void destroy()
	{
		this.removeCallback();
		this.timerManager.destroyTimer(this);
	}
	
	///
	void removeCallback()
	{
		this.callback = null;
	}
	
	///
	void update(Timestamp now)
	{
		if(now >= this.triggerTime)
		{
			this.startTime = now;
			this.triggerCountCounted++;
			this.callback(this.timespan);
			//destroy if we triggered triggerCount times; do not if we want to trigger forever
			if(this.triggerCountCounted != 0 && this.triggerCountCounted >= this.triggerCount)
			{
				this.destroy();
			}
		}
	}
	
	///
	void resetDuration()
	{
		Timestamp tmpTime = this.triggerTime;
		this.triggerTime = tmpTime + this.timespan;
		this.startTime = tmpTime;
		this.triggerCountCounted = 0;
	}
	
	///
	@property Timespan timeLeftUntilNextTrigger()
	{ 
		return this.triggerTime - curSysTime; 
	}
	
	///
	@property Timespan timeElapsedSinceLastTrigger()
	{ 
		return curSysTime - this.startTime; 
	}
	
	///
	@property Timespan timespan()
	{ 
		return this.triggerTime - this.startTime; 
	}
	
	///
	@property float percentageElapsedUntilNextTrigger()
	{ 
		return this.timeElapsedSinceLastTrigger / this.timespan; 
	}
	
private:
	ITimerManager timerManager;
	Timestamp startTime;
	Timestamp triggerTime;
	uint triggerCount = 0;
	uint triggerCountCounted = 0;
	void delegate(Timespan) callback;
	bool active;
}
