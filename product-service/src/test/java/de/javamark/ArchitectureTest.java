/**
 * Architektur-Tests für de.javamark.
 *
 * <p>Erzwingt BCE-Schichtentrennung, Naming Conventions und saubere Imports
 * zur Build-Zeit. Schlägt ein Test fehl, wurde eine Architektur-Regel verletzt.
 *
 * <p>Framework: Taikai (basiert auf ArchUnit)
 *
 * @author Development Team
 * @author Co-Author: Claude (claude-sonnet-4-6, Anthropic) – generiert via java-scaffold-skill
 * @see <a href="https://github.com/enofex/taikai">Taikai</a>
 * @see <a href="https://www.archunit.org">ArchUnit</a>
 */
package de.javamark;

import com.enofex.taikai.Taikai;
import org.junit.jupiter.api.Test;

class ArchitectureTest {

    private static final String BASE_PACKAGE = "de.javamark";

    @Test
    void shouldFollowJavaConventions() {
        Taikai.builder()
                .namespace(BASE_PACKAGE)
                .java(java -> java
                        .noUsageOfDeprecatedAPIs()
                        .methodsShouldNotDeclareGenericExceptions()
                        .imports(imports -> imports
                                .shouldHaveNoCycles()
                                .shouldNotImport("..internal..")
                        )
                        .naming(naming -> naming
                                .classesShouldNotMatch(".*Impl")
                                .interfacesShouldNotHavePrefixI()
                                .constantsShouldFollowConventions()
                        )
                )
                .build()
                .check();
    }

    @Test
    void shouldFollowBCELayerRules() {
        Taikai.builder()
                .namespace(BASE_PACKAGE)
                .java(java -> java
                        .imports(imports -> imports
                                // entity-Schicht darf NICHT von boundary abhängen
                                .shouldNotImport(BASE_PACKAGE + ".boundary..")
                        )
                )
                .build()
                .check();
    }

    @Test
    void shouldFollowNamingConventions() {
        Taikai.builder()
                .namespace(BASE_PACKAGE)
                .java(java -> java
                        .naming(naming -> naming
                                .classesShouldMatch(
                                        BASE_PACKAGE + ".boundary.rest",
                                        ".*Resource|.*Controller"
                                )
                                .classesShouldMatch(
                                        BASE_PACKAGE + ".control",
                                        ".*Service"
                                )
                        )
                )
                .build()
                .check();
    }
}
