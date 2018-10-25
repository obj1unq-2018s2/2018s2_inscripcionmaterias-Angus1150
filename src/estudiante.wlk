import materia.*
import carrera.*
import inscripcion.*

class Estudiante {
	var property materiasAprobadas
	var property carreras
	var creditos
	var property anioCursada
	var property materiasInsc
	var property materiasEnEspera
	method creditos(){
		return creditos
	}
	method setCreditos(num){
		creditos+=num
	}
}
