extends Node

const KILLS = "Kills"
# Creates a constant storing the kills stat
const DAMAGE_DONE = "Damage_done"
# Creates a constant storing the damage done stat
const DAMAGE_TAKEN = "Damage_taken"
# Creates a constant storing the damage taken stat
const DAMAGE_BLOCKED = "Damage_blocked"
# Creates a constant storing the damage blocked stat
const PARRIES = "Parries"
# Creates a constant storing the parries stat
const DEATHS = "Deaths"
# Creates a constant storing the deaths stat
const P1 = "p1"
# Creates a constant storing the p1 stat id
const P2 = "p2"
# Creates a constant storing the p2 stat id

var stats = {
	"p1": {"Kills": 0, "Damage_done": 0, "Damage_taken": 0, "Damage_blocked": 0,
	"Parries": 0, "Deaths": 0},
	
	"p2": {"Kills": 0, "Damage_done": 0, "Damage_taken": 0, "Damage_blocked": 0,
	"Parries": 0, "Deaths": 0}
}
# A varriable storing all the stats of the both players in a dictory and setting them to 0
